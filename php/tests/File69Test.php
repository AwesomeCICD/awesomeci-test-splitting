<?php
use PHPUnit\Framework\TestCase;
use Demo\File69;

class File69Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File69::add(2, 3));
    }
}
