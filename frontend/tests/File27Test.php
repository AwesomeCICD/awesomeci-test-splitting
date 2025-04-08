<?php
use PHPUnit\Framework\TestCase;
use Demo\File27;

class File27Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File27::add(2, 3));
    }
}
